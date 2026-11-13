import 'package:flutter_test/flutter_test.dart';
import 'package:kadian_app/core/selection/selection_intent.dart';

void main() {
  const guard = HintLeakGuard();

  group('一级提示防泄漏', () {
    test('含答案关键词的整句被剔除', () {
      final result = guard.check(
        text: '先看空格前面是不是动词。这里应该用「磨いて」的形式。再看接续。',
        hintLevel: 1,
        answerKeywords: const ['磨いて'],
      );
      expect(result.safe, isFalse);
      expect(result.text.contains('磨いて'), isFalse);
      expect(result.text.contains('先看空格前面'), isTrue);
    });

    test('正确选项原文同样算泄漏', () {
      final result = guard.check(
        text: '答案就是「勉強して」这一项。',
        hintLevel: 1,
        answerKeywords: const [],
        answerLabel: '勉強して',
      );
      expect(result.safe, isFalse);
      expect(result.text.contains('勉強して'), isFalse);
    });

    test('全部句子被剔除时退化为通用引导语', () {
      final result = guard.check(
        text: '磨いて。',
        hintLevel: 1,
        answerKeywords: const ['磨いて'],
      );
      expect(result.safe, isFalse);
      expect(result.text.contains('磨いて'), isFalse);
      expect(result.text.isNotEmpty, isTrue);
    });

    test('单字助词不误杀（长度 <2 的禁词不参与匹配）', () {
      final result = guard.check(
        text: '看助词「は」提示主语。',
        hintLevel: 1,
        answerKeywords: const ['は'],
      );
      expect(result.safe, isTrue);
    });

    test('三级提示允许出现答案', () {
      final result = guard.check(
        text: '完整讲解：这里用「磨いて」连接后续动作。',
        hintLevel: 3,
        answerKeywords: const ['磨いて'],
      );
      expect(result.safe, isTrue);
    });

    test('流式遮蔽把答案词替换成占位符', () {
      final masked = guard.maskLive(
        '这里应该用磨いて，然后接から。',
        const ['磨いて'],
        '',
      );
      expect(masked.contains('磨いて'), isFalse);
      expect(masked.contains('＿'), isTrue);
    });
  });

  group('选中类型与菜单过滤', () {
    const classifier = SelectionClassifier();

    test('单个汉字/假名是单词，短句是短语，带句号是句子', () {
      expect(classifier.classify('手続き'), SelectionKind.phrase);
      expect(classifier.classify('窓'), SelectionKind.word);
      expect(classifier.classify('窓口で手続きをした。'), SelectionKind.sentence);
      expect(
        classifier.classify('窓口で手続きをした。必要な書類は事前に確認しておいたので、'
            '待たされずに済んだ。ただ、住民票の写しが必要だと言われて、近くのコンビニまで'
            '取りに行くことになった。'),
        SelectionKind.paragraph,
      );
    });

    test('英文单词与句子分流', () {
      expect(classifier.classify('outcome'), SelectionKind.word);
      expect(classifier.classify('results actually achieved'), SelectionKind.phrase);
      expect(
        classifier.classify('The team kept the four-day week.'),
        SelectionKind.sentence,
      );
    });

    test('选项与题干按标记识别', () {
      expect(
        classifier.classify('磨いて', isOption: true),
        SelectionKind.option,
      );
      expect(classifier.classify('题干', isStem: true), SelectionKind.stem);
    });

    test('段落不提供辨析，选项不提供翻译', () {
      expect(
        classifier.intentsFor(SelectionKind.paragraph),
        isNot(contains(HintIntent.contrast)),
      );
      expect(
        classifier.intentsFor(SelectionKind.option),
        isNot(contains(HintIntent.translate)),
      );
      expect(
        classifier.intentsFor(SelectionKind.word),
        contains(HintIntent.meaning),
      );
    });
  });

  group('提示层级策略', () {
    const policy = HintLevelPolicy();

    test('逐级解锁，封顶 4 级', () {
      expect(policy.nextLevel(0, answerRevealed: false), 1);
      expect(policy.nextLevel(3, answerRevealed: false), 4);
      expect(policy.nextLevel(4, answerRevealed: false), 4);
      expect(policy.nextLevel(1, answerRevealed: true), 4);
    });

    test('第三次请求强制讲解', () {
      expect(policy.forcesExplain(2), isFalse);
      expect(policy.forcesExplain(3), isTrue);
    });

    test('一二两级必须隐藏答案原文', () {
      expect(policy.mustHideAnswer(1), isTrue);
      expect(policy.mustHideAnswer(2), isTrue);
      expect(policy.mustHideAnswer(3), isFalse);
    });
  });
}
