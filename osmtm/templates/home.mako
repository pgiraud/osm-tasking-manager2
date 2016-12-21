# -*- coding: utf-8 -*-
<%namespace file="custom.mako" name="custom"/>
<%inherit file="base.mako"/>
<%namespace file="helpers.mako" name="helpers"/>
<%block name="header">
</%block>
<%block name="content">
<%
base_url = request.route_path('home')
priorities = [_('urgent'), _('high'), _('medium'), _('low')]
%>
<div class="container">
  <div class="col-md-6">
    ${custom.main_page_right_panel()}
  </div>
  <div class="col-md-6">
    <h3>${_('Projects')}</h3>
    <form role="form"
          action="${request.current_route_url('projects')}"
          method="GET">
      <div class="form-group left-inner-addon">
        <i class="glyphicon glyphicon-search text-muted"></i>
        <input type="search" class="form-control"
               name="search" placeholder="${_('Search')}">
      </div>
    </form>
    <div class="panel panel-default">
      <ul class="list-group">
      % if paginator.items:
        % for project in paginator.items:
          ${project_block(project=project, base_url=base_url,
                          priorities=priorities)}
        % endfor
      % endif
      <li class="project list-group-item text-center">
        <a class="btn btn-link"
            href="${request.route_url('projects')}">
          <i class="glyphicon glyphicon-share-alt"></i>
          ${_('View complete list')}</a>
      </li>
      </ul>
    </div>
  </div>
</div>
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
  <div>
  % for label in project.labels:
  ${helpers.display_label(label)}
  % endfor
  </div>
  <div>
  ${helpers.display_project_info(project=project)}
  </div>
</li>
</%def>
