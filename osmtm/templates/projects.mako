# -*- coding: utf-8 -*-
<%inherit file="base.mako"/>
<%namespace file="helpers.mako" name="helpers"/>

<%block name="header">
</%block>

<%block name="content">
<%
base_url = request.route_path('home')
priorities = [_('urgent'), _('high'), _('medium'), _('low')]
%>
<%
  total = ngettext('${total} project', '${total} projects', paginator.item_count, mapping={'total': paginator.item_count})
%>
<%
  qs = dict(request.GET)
  default_sort = qs.get('sort_by', 'priority') == 'priority'
  default_direction = qs.get('direction', 'asc') == 'asc'
  default_search = qs.get('search', '') == ''
  my_projects = qs.get('my_projects')
  show_archived = qs.get('show_archived')
  default_filter = default_sort and default_direction and default_search and \
    not my_projects and not show_archived
%>

<form role="form"
      action="${request.current_route_url()}"
      method="GET">
  <input type="hidden" name="sort_by"
         value="${request.params.get('sort_by', 'priority')}">
  <input type="hidden" name="direction"
         value="${request.params.get('direction', 'asc')}">

<div class="container">
  <div class="row">
    <div class="col-md-8">
      <h3>${_('Projects')}</h3>
      <div class="row">
        <div class="col-md-12">
          <div class="form-group left-inner-addon">
            <i class="glyphicon glyphicon-search text-muted"></i>
            <input type="search" class="form-control"
                   name="search" placeholder="${_('Search')}"
                   value="${request.params.get('search', '')}">
          </div>
        </div>
      </div>
      % if not default_filter:
      <div class="row">
        <div class="col-md-12">
          <div class="form-group">
            <a class="btn btn-link btn-sm"
               href="${request.route_path('projects')}">
              <i class="glyphicon glyphicon-remove"></i>
              ${_('Clear current search query, filters, and sorts')}
            </a>
          </div>
        </div>
      </div>
      % endif
      <div class="panel panel-default">
        <div class="panel-heading panel-heading-no-padding">
          <div class="navbar">
            <strong class="navbar-text">
              ${total}
            </strong>
            <div class="navbar-right navbar-form">
              ${other_filters()}
              ${label_filter()}
              ${sort_filter()}
              &nbsp;
            </div>
          </div>
        </div>
        <ul class="list-group">
        % if paginator.items:
            % for project in paginator.items:
              ${project_block(project=project, base_url=base_url,
                              priorities=priorities)}
            % endfor
        % endif
        </ul>
      </div>
      ${paginate()}
    </div>
    <div class="col-md-4">
      % for label in labels:
        <%
          if request.locale_name:
            label.locale = request.locale_name
        %>
        % if label.name in search['labels'] and label.description:
          <div class="panel panel-default">
            <div class="panel-heading">
              <h3 class="panel-title">
              <span class="label"
                style="background-color:${label.color}">
                ${label.name}
              </span>
              </h3>
            </div>
            <div class="panel-body">
              ${label.description}
            </div>
          </div>
        % endif
      % endfor
    </div>
  </div>
</div>
</form>
</%block>

<%def name="project_block(project, base_url, priorities)">
<%
    import math
    from osmtm.mako_filters import markdown_filter
    if request.locale_name:
        project.locale = request.locale_name

    if project.status == project.status_archived:
        status = 'Archived'
    elif project.status == project.status_draft:
        status = 'Draft'
    else:
        status = ''
%>
<li class="project list-group-item ${status.lower()}">
  <ul class="nav project-stats">
    <li>
      <table>
        <tr>
          <%
            locked = project.get_locked()
            # plural forms are defined ngettext(singular, plural, n, ...)
            # 'n' is the conditional for choosing the right plural form
            title = ngettext('${locked} user is currently working on this project', '${locked} users are currently working on this project', locked, mapping={'locked': locked})
          %>
          % if locked:
          <td>
            <span title="${title}" class="text-muted">
              <span class="glyphicon glyphicon-user"></span>
              ${locked}
            </span>
            &nbsp;
          </td>
          % endif
          <td>
            <div class="progress">
              <div style="width: ${project.done}%;" class="progress-bar progress-bar-warning"></div>
              <div style="width: ${project.validated}%;" class="progress-bar progress-bar-success"></div>
            </div>
          </td>
          <td>&nbsp;${int(math.floor(project.done + project.validated))}%</td>
        </tr>
      </table>
    </li>
  </ul>
  <h4>
    <a href="${base_url}project/${project.id}">#${project.id} ${project.name}
    </a>
  </h4>
  <div class="clear"></div>
  <div class="world_map">
    % if project.area:
    <%
        from geoalchemy2 import shape
        centroid = shape.to_shape(project.area.centroid)
    %>
    <div style="top: ${(-centroid.y + 90) * 60 / 180 - 1}px; left: ${(centroid.x + 180) * 120 / 360 - 1}px;" class="marker"></div>
    % endif
  </div>
  ${project.short_description | markdown_filter, n}
  <div class="clear"></div>
  ${helpers.display_project_labels(project=project)}
  <br>
  ${helpers.display_project_info(project=project)}
  <br>
</li>
</%def>

<%def name="paginate()">
<div class="text-center">
  <div class="btn-group btn-group-xs">
    <% link_attr={"class": "btn btn-small btn-default"} %>
    <% curpage_attr={"class": "btn btn-default btn-primary"} %>
    <% dotdot_attr={"class": "btn btn-default btn-small disabled"} %>
    ${paginator.pager(format="$link_previous ~2~ $link_next",
                      link_attr=link_attr,
                      curpage_attr=curpage_attr,
                      dotdot_attr=dotdot_attr)}
  </div>
</div>
</%def>

<%def name="other_filters()">
% if user and user.username:
<div class="btn-group">
  <button type="button" class="btn btn-default btn-sm dropdown-toggle"
          data-toggle="dropdown">
    ${_('Filters')}
    <span class="caret"></span>
  </button>
  <ul class="dropdown-menu" role="menu">
    <li>
      <%
      qs = dict(request.GET)
      checked = 'my_projects' in qs
      if not checked:
        qs['my_projects'] = 'on'
      else:
        qs.pop('my_projects', None)
      %>
      <a href="${request.current_route_url(_query=qs.items())}">
        <i class="glyphicon glyphicon-ok"
          % if not checked:
          style="visibility:hidden"
          % endif
          ></i>
        ${_('Your projects')}
      </a>
    </li>
    % if user.is_admin or user.is_project_manager:
    <li>
      <%
      qs = dict(request.GET)
      checked = 'show_archived' in qs
      if not checked:
        qs['show_archived'] = 'on'
      else:
        qs.pop('show_archived', None)
      %>
      <a href="${request.current_route_url(_query=qs.items())}">
        <i class="glyphicon glyphicon-ok"
          % if not checked:
          style="visibility:hidden"
          % endif
          ></i>
        ${_('Include archived projects')}
      </a>
    </li>
    % endif
  </ul>
</div>
% endif
</%def>

<%def name="sort_filter()">
<%
sorts = [('priority', 'asc', _('High priority first')),
         ('created', 'desc', _('Creation date')),
         ('last_update', 'desc', _('Last update'))]
%>
<div class="btn-group">
  <button type="button" class="btn btn-default btn-sm dropdown-toggle"
          data-toggle="dropdown">
    ${_('Sort')}
    <span class="caret"></span>
  </button>
  <ul class="dropdown-menu" role="menu">
    % for sort in sorts:
    <%
    qs = dict(request.GET)
    sort_by = qs.get('sort_by', 'priority')
    direction = qs.get('direction', 'asc')
    qs['sort_by'] = sort[0]
    qs['direction'] = sort[1]
    %>
    <li>
      <a href="${request.current_route_url(_query=qs.items())}">
        <i class="glyphicon glyphicon-ok"
          % if sort[0] != sort_by or sort[1] != direction:
          style="visibility:hidden"
          % endif
          ></i>
        ${sort[2]}
      </a>
    </li>
    % endfor
  </ul>
</div>
</%def>

<%def name="label_filter()">
<div class="btn-group">
  <button type="button" class="btn btn-default btn-sm dropdown-toggle"
          data-toggle="dropdown">
    ${_('Labels')}
    <span class="caret"></span>
  </button>
  <ul class="dropdown-menu" role="menu">
    % for label in labels:
    <%
    import re
    qs = dict(request.GET)
    label_id = label.name
    if re.findall(ur'\s', label_id):
      label_id = '\"' + label_id + '\"'
    label_filter = 'label:%s' % label_id
    search_filter = qs.get('search', '')
    found = False
    if label_filter in search_filter:
      found = True
      qs['search'] = qs['search'].replace(label_filter, '')
    else:
      qs['search'] = (search_filter + ' ' + label_filter).strip()
    %>
    <li>
      <a href="${request.current_route_url(_query=qs.items())}">
        <i class="glyphicon glyphicon-ok"
          % if not found:
          style="visibility:hidden"
          % endif
          ></i>
        <span class="label" style="background-color: ${label.color}">
        ${label.name}
        </span>
      </a>
    </li>
    % endfor
  </ul>
</div>
</%def>
