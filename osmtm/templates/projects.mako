# -*- coding: utf-8 -*-
<%namespace file="custom.mako" name="custom"/>
<%inherit file="base.mako"/>
<%block name="header">
</%block>
<%block name="content">
<div class="container">
  <div class="col-md-7">
    <h3>${_('Projects')}</h3>
    <%namespace name="projects_list" file="projects.list.mako"/>
    <%include file="projects.filters.mako" />
    % if paginator.items:
        ${projects_list.render(projects=paginator)}
    % endif
  </div>
  <div class="col-md-5">
  </div>
</div>
</%block>
