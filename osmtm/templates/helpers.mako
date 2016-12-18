<%def name="display_project_info(project)">
  <%
  priorities = [_('urgent'), _('high'), _('medium'), _('low')]
  %>
  <small class="text-muted">
    % if project.private:
    <span class="glyphicon glyphicon-lock"
          title="${_('Access to this project is limited')}"></span> -
    % endif
    % if project.author:
    <span>${_('Created by')} <a href="${request.route_path('user',username=project.author.username)}">${project.author.username}</a></span> -
    % endif
    <span>${_('Updated')} <span class="timeago" title="${project.last_update}Z"></span></span> -
    <span>${_('Priority:')} ${priorities[project.priority]}</span>
    % if status:
    - <span>${_(status)}</span>
    % endif
  </small>
</%def>

<%def name="display_project_labels(project)">
  % for label in project.labels:
    <%
      import re
      label_id = label.name
      if re.findall(ur'\s', label_id):
        label_id = '\"' + label_id + '\"'
    %>
  <a class="label label-default"
     style="background-color: ${label.color}; color:white;"
     href="${request.route_url('home', _query={'search': 'label:' + label_id})}">${label.name}</a>
  % endfor
</%def>
