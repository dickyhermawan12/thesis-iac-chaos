from fastapi import APIRouter, HTTPException, status, Depends
from sqlalchemy.orm import Session

from .. import models, schemas, utils
from ..database import get_db

router = APIRouter(prefix="/users", tags=["Users"])

# ------------------------------ GET ------------------------------ #


# Get all users
@router.get("/", response_model=list[schemas.UserOut])
def get_users(db: Session = Depends(get_db)):
    # Query for all users
    users = db.query(models.User).all()

    return users


# Get user by email use query parameter
@router.get("/email", response_model=schemas.UserOut)
def get_user_by_email(
    email: str,
    db: Session = Depends(get_db),
):
    # Query for user with email
    user = db.query(models.User).filter(models.User.email == email).first()

    # If user does not exist, raise an exception
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"User with email: {email} does not exist",
        )

    return user


# Get user by id
@router.get("/{id}", response_model=schemas.UserOut)
def get_user(
    id: int,
    db: Session = Depends(get_db),
):
    # Query for user with id
    user = db.query(models.User).filter(models.User.user_id == id).first()

    # If user does not exist, raise an exception
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"User with id: {id} does not exist",
        )

    return user


# ------------------------------ POST ------------------------------ #


# Create a new user
@router.post("/", status_code=status.HTTP_201_CREATED, response_model=schemas.UserOut)
def create_user(user: schemas.UserCreate, db: Session = Depends(get_db)):
    # Check if user with email already exists
    user_exists = (
        db.query(models.User).filter(models.User.email == user.email).first()
        is not None
    )

    # If user exists, raise an exception
    if user_exists:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"User with email: {user.email} already exists",
        )

    # Hash password
    hashed_password = utils.hash(user.password)
    user.password = hashed_password

    # Create new user
    new_user = models.User(**user.dict())
    db.add(new_user)
    db.commit()
    db.refresh(new_user)

    return new_user


# ------------------------------ DELETE ------------------------------ #


# Delete all users (for testing purposes)
@router.delete("/", status_code=status.HTTP_204_NO_CONTENT)
def delete_all_users(db: Session = Depends(get_db)):
    # Query for all users
    users = db.query(models.User).all()

    # Delete all users
    for user in users:
        db.delete(user)
    db.commit()

    return None
