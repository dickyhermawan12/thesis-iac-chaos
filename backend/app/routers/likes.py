from fastapi import APIRouter, HTTPException, status, Depends
from sqlalchemy.orm import Session

from .. import schemas, database, models, oauth2

router = APIRouter(prefix="/like", tags=["Like"])

# ------------------------------ GET ------------------------------ #


# Get specific like for a post for a user
@router.get("/{id}", response_model=schemas.Like)
def get_like(
    id: int,
    db: Session = Depends(database.get_db),
    current_user: int = Depends(oauth2.get_current_user),
):
    # Check if post exists
    post = db.query(models.Post).filter(models.Post.post_id == id).first()

    # If post does not exist, raise an exception
    if not post:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Post with id: {id} does not exist",
        )

    # Check if user has liked the post
    like = (
        db.query(models.Like)
        .filter(models.Like.post_id == id, models.Like.user_id == current_user.user_id)
        .first()
    )

    # If user has liked the post, return dir = 1
    # If user has not liked the post, return dir = 0
    dir = 1 if like else 0

    return {
        "post_id": id,
        "dir": dir,
    }


# Get like count for a post
@router.get("/count/{id}", response_model=schemas.LikeCount)
def get_like_count(
    id: int,
    db: Session = Depends(database.get_db),
    current_user: int = Depends(oauth2.get_current_user),
):
    # Check if post exists
    post = db.query(models.Post).filter(models.Post.post_id == id).first()

    # If post does not exist, raise an exception
    if not post:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Post with id: {id} does not exist",
        )

    # Get like count for post
    like_count = db.query(models.Like).filter(models.Like.post_id == id).count()

    return {"count": like_count}


# ------------------------------ POST ------------------------------ #


# Like or unlike a post
@router.post("/", status_code=status.HTTP_201_CREATED)
def like(
    like: schemas.Like,
    db: Session = Depends(database.get_db),
    current_user: int = Depends(oauth2.get_current_user),
):
    # Check if post exists
    post = db.query(models.Post).filter(models.Post.post_id == like.post_id).first()

    # If post does not exist, raise an exception
    if not post:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Post with id: {like.post_id} does not exist",
        )

    # Check if user has already liked the post
    like_query = db.query(models.Like).filter(
        models.Like.post_id == like.post_id, models.Like.user_id == current_user.user_id
    )
    found_like = like_query.first()

    # If user is liking the post, create a new like
    # If user is unliking the post, delete the like
    # dir = 1 acts as a like, dir = 0 acts as an unlike
    if like.dir == 1:
        # If user has already liked the post, raise an exception
        if found_like:
            raise HTTPException(
                status_code=status.HTTP_409_CONFLICT,
                detail=f"User {current_user.user_id} has already liked on post {like.post_id}",
            )

        # Create new like
        new_like = models.Like(post_id=like.post_id, user_id=current_user.user_id)
        db.add(new_like)
        db.commit()

        return {"message": "successfully added like", "dir": like.dir}
    else:
        # If user has not liked the post, raise an exception
        if not found_like:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND, detail="Like does not exist"
            )

        # Delete like
        like_query.delete(synchronize_session=False)
        db.commit()

        return {"message": "successfully deleted like", "dir": like.dir}
