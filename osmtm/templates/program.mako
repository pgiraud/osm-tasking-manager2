# -*- coding: utf-8 -*-
<%inherit file="base.mako"/>
<%def name="title()">${program.name}</%def>

<%block name="header">
  <h1>
    <span class="badge program">Program</span>
    ${program.name}
  </h1>
</%block>

<%block name="content">
<div class="container">
  <div class="row">
    <div class="col-md-6">
      <h2>List of Projects in this Program</h2>
      <%include file="projects.filters.mako" />
      <%namespace name="projects_list" file="projects.list.mako"/>
      % if projects.items:
          ${projects_list.render(projects=projects)}
      % endif
    </div>
    <div class="col-md-6">
      <h2>Your latest mapping in this Program</h2>
        <ul>
          <li>Some task in project #xxx</li>
          <li>Some task in project #xxx</li>
          <li>Some task in project #xxx</li>
          <li>Some task in project #xxx</li>
          <li>Some task in project #xxx</li>
        </ul>
      <h2>${_('Program information')}</h2>
      <h3>${_('Description')}</h3>
      <div>
        ${program.description}
      </div>
      <h3>Useful links</h3>
      <h3>Who to contact</h3>
    </div>
  </div>
</div>
</%block>
