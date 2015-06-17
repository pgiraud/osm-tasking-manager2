<%def name="render(projects)">
  % for project in projects.items:
    ${project_block(project=project)}
  % endfor
  ${paginate(projects)}
</%def>
<%def name="project_block(project)">
<%
    base_url = request.route_path('home')
    priorities = [_('urgent'), _('high'), _('medium'), _('low')]

    import math
    from osmtm.mako_filters import markdown_filter
    if request.locale_name:
        project.locale = request.locale_name
    priority = priorities[project.priority]

    if project.status == project.status_archived:
        status = 'Archived'
    elif project.status == project.status_draft:
        status = 'Draft'
    else:
        status = ''
%>
<div class="project well ${status.lower()}">
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
  <small class="text-muted">
    % if project.private:
    <span class="glyphicon glyphicon-lock"
          title="${_('Access to this project is limited')}"></span> -
    % endif
    % if project.author:
    <span>${_('Created by')} <a href="${request.route_path('user',username=project.author.username)}">${project.author.username}</a></span> -
    % endif
    <span>${_('Updated')} <span class="timeago" title="${project.last_update}Z"></span></span> -
    <span>${_('Priority:')} ${priority}</span>
    % if status:
    - <span>${_(status)}</span>
    % endif
  </small>
</div>
</%def>

<%def name="paginate(paginator)">
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
