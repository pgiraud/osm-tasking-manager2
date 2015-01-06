#!env/bin/python
__requires__ = 'osmtm'

import os
import sys
import transaction

from sqlalchemy import create_engine

from pyramid.paster import (
    get_appsettings,
    setup_logging,
    )

from osmtm.models import (
    DBSession,
    Project,
    TaskState,
    )

from sqlalchemy import (
    and_,
    distinct,
)

engine = create_engine('postgresql://www-data:www-data@localhost/osmtm')
DBSession.configure(bind=engine)
with transaction.manager:
    ids = DBSession.query(Project.id) \
        .filter(Project.changeset_comment.ilike('%#mapgive%')).all()

    filter = and_(TaskState.state==TaskState.state_done, TaskState.project_id.in_(ids))
    done = DBSession.query(distinct(TaskState.user_id)).filter(filter).all()

    print len(done)
