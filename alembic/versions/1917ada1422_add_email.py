"""Add email

Revision ID: 1917ada1422
Revises: 5002e75c0604
Create Date: 2016-12-30 18:20:25.801828

"""

# revision identifiers, used by Alembic.
revision = '1917ada1422'
down_revision = '5002e75c0604'

from alembic import op
import sqlalchemy as sa


def upgrade():
    op.add_column('users', sa.Column('confirmed_on', sa.DateTime(), nullable=True))
    op.add_column('users', sa.Column('email', sa.Unicode(), nullable=True))

    op.add_column('users', sa.Column('confirmed', sa.Boolean(), nullable=True))
    op.execute("""
        UPDATE users SET confirmed='f'
    """)
    op.alter_column('users', 'confirmed', nullable=False)


def downgrade():
    op.drop_column('users', 'email')
    op.drop_column('users', 'confirmed_on')
    op.drop_column('users', 'confirmed')
