from __future__ import annotations

import time

import pytest

from app import auth


def test_token_roundtrip():
    token = auth.issue_token("device-abc")
    payload = auth.verify_token(token)
    assert payload["sub"] == "device-abc"
    assert payload["exp"] > payload["iat"]


def test_fingerprint_is_stable_and_short():
    token = auth.issue_token("device-abc")
    assert auth.fingerprint(token) == auth.fingerprint(token)
    assert len(auth.fingerprint(token)) == 12
    assert token not in auth.fingerprint(token)


def test_tampered_signature_rejected():
    token = auth.issue_token("device-abc")
    body, signature = token.split(".", 1)
    tampered = f"{body}.{signature[:-2]}xx"
    with pytest.raises(auth.TokenError):
        auth.verify_token(tampered)


def test_tampered_payload_rejected():
    token = auth.issue_token("device-abc")
    body, signature = token.split(".", 1)
    forged_body = auth._b64encode(b'{"sub":"attacker","exp":9999999999}')
    with pytest.raises(auth.TokenError):
        auth.verify_token(f"{forged_body}.{signature}")


def test_expired_token_rejected():
    token = auth.issue_token("device-abc", ttl_days=-1)
    with pytest.raises(auth.TokenError, match="过期"):
        auth.verify_token(token)


def test_empty_device_id_rejected():
    with pytest.raises(auth.TokenError):
        auth.issue_token("")


def test_expiry_is_in_the_future():
    token = auth.issue_token("device-abc", ttl_days=1)
    payload = auth.verify_token(token)
    assert payload["exp"] - int(time.time()) > 86000
