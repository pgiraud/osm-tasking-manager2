# -*- coding: utf-8 -*-
<%inherit file="base.mako"/>
<%block name="header">
<h1>${_('Edit Program')}</h1>
</%block>
<%block name="content">
<%
base_url = request.route_path('home')
%>
<div class="container">
  <form method="post" action="" class="form-horizontal">
    <div class="form-group">
      <label class="control-label" for="id_name">${_('Name')}</label>
      <input type="text" class="form-control" id="id_name" name="name" value="${program.name if program else ''}"
      placeholder="${_('Program Name')}" />
    </div>
    <div class="form-group">
      <label class="control-label" for="id_description">${_('Description')}</label>
      <textarea class="form-control" id="id_description" name="description" rows="6"
        placeholder="${_('Program Description')}">${program.description if program else ''}</textarea>
    </div>
    <div class="form-group">
      % if program:
      <input type="submit" class="btn btn-success" value="${_('Save the modifications')}" id="id_submit" name="form.submitted"/>
      % else:
      <input type="submit" class="btn btn-success" value="${_('Create new Program')}" id="id_submit" name="form.submitted"/>
      % endif
      % if program:
      <a class="btn btn-danger" href="${request.route_path('program_delete', program=program.id)}">${_('Delete')}</a>
      % endif
      <a class="btn btn-default pull-right" href="${request.route_path('programs')}">${_('Cancel')}</a>
    </div>
  </form>
</div>
</%block>
