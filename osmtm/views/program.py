from pyramid.view import view_config
from pyramid.url import route_path
from pyramid.httpexceptions import (
    HTTPFound,
)
from ..models import (
    DBSession,
    Program,
)

from .views import list_projects


@view_config(route_name='programs', renderer='programs.mako')
def programs(request):
    programs = DBSession.query(Program).all()

    return dict(page_id="programs", programs=programs)


@view_config(route_name='program', renderer='program.mako')
def program(request):
    _ = request.translate
    id = request.matchdict['program']
    program = DBSession.query(Program).get(id)

    if program is None:
        _ = request.translate
        request.session.flash(_("This program doesn't  exist !"), 'success')
        return HTTPFound(location=route_path('programs', request))

    projects = list_projects(request, items_per_page=2)

    return dict(page_id="program", program=program, projects=projects)


@view_config(route_name='program_delete', renderer='program.delete.mako',
             permission='program_edit')
def program_delete(request):
    _ = request.translate
    id = request.matchdict['program']
    program = DBSession.query(Program).get(id)

    if not program:
        request.session.flash(_("This program doesn't exist !"), 'success')
        return HTTPFound(location=route_path('programs', request))

    if 'form.submitted' in request.params:
        DBSession.delete(program)
        DBSession.flush()
        request.session.flash(_('Program was correctly deleted !'), 'success')
        return HTTPFound(location=route_path('programs', request))

    return dict(page_id="program", program=program)


@view_config(route_name='program_new', renderer='program.edit.mako',
             permission='program_edit')
@view_config(route_name='program_edit', renderer='program.edit.mako',
             permission='program_edit')
def program_edit(request):
    _ = request.translate
    if 'program' in request.matchdict:
        id = request.matchdict['program']
        program = DBSession.query(Program).get(id)
    else:
        program = None

    if 'form.submitted' in request.params:
        if not program:
            program = Program()
            DBSession.add(program)
            DBSession.flush()
            request.session.flash(_('Program created!'), 'success')
        else:
            request.session.flash(_('Program updated!'), 'success')

        program.name = request.params['name']
        program.description = request.params['description']

        DBSession.add(program)
        return HTTPFound(location=route_path('programs', request))
    return dict(page_id="programs", program=program)
