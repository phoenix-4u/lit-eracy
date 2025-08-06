from ..models.token_blacklist import TokenBlacklist
from ..database import SessionLocal

def blacklist_token(jti: str):
    db = SessionLocal()
    entry = TokenBlacklist(jti=jti)
    db.add(entry)
    db.commit()
    db.close()

def is_token_blacklisted(jti: str) -> bool:
    db = SessionLocal()
    exists = db.query(TokenBlacklist).filter(TokenBlacklist.jti == jti).first() is not None
    db.close()
    return exists
