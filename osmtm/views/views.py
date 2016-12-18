from pyramid.view import view_config
from pyramid.httpexceptions import HTTPFound, HTTPUnauthorized

from ..models import (
    DBSession,
    Project,
    User,
    TaskLock,
    Label,
)

from .project import check_project_expiration

from pyramid.security import authenticated_userid


@view_config(route_name='home', renderer='home.mako')
def home(request):
    check_project_expiration()

    # no user in the DB yet
    if DBSession.query(User).filter(User.role == User.role_admin) \
                .count() == 0:   # pragma: no cover
        request.override_renderer = 'start.mako'
        return dict(page_id="start")

    return dict(page_id="home")


@view_config(route_name='about', renderer='about.mako')
def about(request):
    return dict(page_id="about")


@view_config(route_name="user_prefered_editor", renderer='json')
def user_prefered_editor(request):
    editor = request.matchdict['editor']
    request.response.set_cookie('prefered_editor', value=editor,
                                max_age=20 * 7 * 24 * 60 * 60)

    return dict()


@view_config(route_name="user_prefered_language", renderer='json')
def user_prefered_language(request):
    language = request.matchdict['language']
    request.response.set_cookie('_LOCALE_', value=language,
                                max_age=20 * 7 * 24 * 60 * 60)
    return dict()


@view_config(context='pyramid.httpexceptions.HTTPUnauthorized')
def unauthorized(request):
    if request.is_xhr:
        return HTTPUnauthorized()
    return HTTPFound(request.route_path('login',
                                        _query=[('came_from', request.url)]))
