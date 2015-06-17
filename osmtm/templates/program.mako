# -*- coding: utf-8 -*-
<%inherit file="base.mako"/>
<%def name="title()">${program.name}</%def>

<%block name="header">
  <h1>${program.name}</h1>
</%block>

<%block name="content">
<div class="container">
  <div class="col-md-6">
    <%include file="projects.filters.mako" />
    <%namespace name="projects_list" file="projects.list.mako"/>
    % if projects.items:
        ${projects_list.render(projects=projects)}
    % endif
  </div>
  <div class="col-md-6">
    <h3>${_('Program information')}</h3>
    <h4>${_('Description')}</h4>
    <div>
      ${program.description}
    </div>
  </div>
</div>
</%block>
