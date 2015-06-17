# -*- coding: utf-8 -*-
<%inherit file="base.mako"/>
<%def name="title()">${_('Programs')}</%def>
<%block name="header">
<h1>${_('Programs')}</h1>
</%block>
<%block name="content">
<%
base_url = request.route_path('home')
%>
<div class="container">
  <div class="row">
    <div class="col-md-8">
      % for program in programs:
        <h4>
          <a href="${base_url}program/${program.id}">${program.name}</a>
          <a href="${request.route_path('program_edit', program=program.id)}" class="btn pull-right">${_('Edit')}</a><br />
        </h4>
        <div>
          ${program.description}
        </div>
      % endfor
    </div>
    <div class="col-md-4">
      <a href="${request.route_path('program_new')}" class="btn btn-default">${_('Create new Program')}</a>
    </div>
  </div>
</div>
</%block>
