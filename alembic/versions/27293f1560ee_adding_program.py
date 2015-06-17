"""Adding program

Revision ID: 27293f1560ee
Revises: 4290a873fda7
Create Date: 2015-06-13 12:17:39.499025

"""

# revision identifiers, used by Alembic.
revision = '27293f1560ee'
down_revision = '4290a873fda7'

from alembic import op
import sqlalchemy as sa


def upgrade():
    op.create_table('program',
    sa.Column('id', sa.Integer(), nullable=False),
    sa.Column('name', sa.Unicode(), nullable=True),
    sa.Column('description', sa.Unicode(), nullable=True),
    sa.PrimaryKeyConstraint('id')
    )
    op.add_column('project', sa.Column('program_id', sa.Integer(), nullable=True))


def downgrade():
    op.drop_column('project', 'program_id')
    op.drop_table('program')
