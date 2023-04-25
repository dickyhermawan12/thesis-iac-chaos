from fastapi import APIRouter, HTTPException, Response, status, Depends
from typing import List, Optional

from sqlalchemy import func
from sqlalchemy.orm import Session

from .. import models, schemas, oauth2
from ..database import get_db


router = APIRouter(prefix="/posts", tags=["Posts"])

# ------------------------------ GET ------------------------------ #


# Get all posts
@router.get("/", response_model=List[schemas.PostOut])
def get_posts(
    db: Session = Depends(get_db),
    limit: int = 10,
    skip: int = 0,
    search: Optional[str] = "",
):
    # Query for posts including number of likes
    # Filter by search term, with pagination
    posts = (
        db.query(models.Post, func.count(models.Like.post_id).label("likes"))
        .join(models.Like, models.Like.post_id == models.Post.id, isouter=True)
        .group_by(models.Post.id)
        .filter(models.Post.title.contains(search))
        .limit(limit)
        .offset(skip)
        .all()
    )

    return posts


# Get post by id
@router.get("/{id}", response_model=schemas.PostOut)
def get_post(
    id: int,
    db: Session = Depends(get_db),
):
    # Query for post with id, including number of likes
    post = (
        db.query(models.Post, func.count(models.Like.post_id).label("likes"))
        .join(models.Like, models.Like.post_id == models.Post.id, isouter=True)
        .group_by(models.Post.id)
        .filter(models.Post.id == id)
        .first()
    )

    # If post does not exist, raise an exception
    if not post:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"post with id: {id} was not found",
        )

    return post


# ------------------------------ POST ------------------------------ #


# Create new post
@router.post("/", status_code=status.HTTP_201_CREATED, response_model=schemas.Post)
def create_posts(
    post: schemas.PostCreate,
    db: Session = Depends(get_db),
    current_user: int = Depends(oauth2.get_current_user),
):
    # Create new post
    new_post = models.Post(owner_id=current_user.id, **post.dict())
    db.add(new_post)
    db.commit()
    db.refresh(new_post)

    return new_post


# ------------------------------ PUT ------------------------------ #


# Update post by id
@router.put("/{id}", response_model=schemas.Post)
def update_post(
    id: int,
    updated_post: schemas.PostCreate,
    db: Session = Depends(get_db),
    current_user: int = Depends(oauth2.get_current_user),
):
    # Query for post with id
    post_query = db.query(models.Post).filter(models.Post.id == id)

    # Get first result
    post = post_query.first()

    # If post does not exist, raise an exception
    if post == None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"post with id: {id} does not exist",
        )

    # If post exists, check if user is owner
    if post.owner_id != current_user.id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not authorized to perform requested action",
        )

    # If user is owner, update post
    post_query.update(updated_post.dict(), synchronize_session=False)
    db.commit()

    return post_query.first()


# ------------------------------ DELETE ------------------------------ #


# Delete post by id
@router.delete("/{id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_post(
    id: int,
    db: Session = Depends(get_db),
    current_user: int = Depends(oauth2.get_current_user),
):
    # Query for post with id
    post_query = db.query(models.Post).filter(models.Post.id == id)

    # Get first result
    post = post_query.first()

    # If post does not exist, raise an exception
    if post == None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"post with id: {id} does not exist",
        )

    # If post exists, check if user is owner
    if post.owner_id != current_user.id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not authorized to perform requested action",
        )

    # If user is owner, delete post
    post_query.delete(synchronize_session=False)
    db.commit()

    return Response(status_code=status.HTTP_204_NO_CONTENT)
