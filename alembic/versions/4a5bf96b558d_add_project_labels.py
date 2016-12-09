"""Add project labels

Revision ID: 4a5bf96b558d
Revises: 5002e75c0604
Create Date: 2016-06-02 23:42:17.332659

"""

# revision identifiers, used by Alembic.
revision = '4a5bf96b558d'
down_revision = '5002e75c0604'

from alembic import op
import sqlalchemy as sa


def upgrade():
    op.create_table(
        'label',
        sa.Column('id', sa.Integer, primary_key=True),
        sa.Column('name', sa.Unicode)
    )


    project_labels_table = op.create_table(
        'project_labels',
        sa.Column('project', sa.Integer),
        sa.Column('label', sa.Integer),
        sa.ForeignKeyConstraint(['project'], ['project.id']),
        sa.ForeignKeyConstraint(['label'], ['label.id'])
    )


def downgrade():
    op.drop_table('project_labels')
    op.drop_table('label')
