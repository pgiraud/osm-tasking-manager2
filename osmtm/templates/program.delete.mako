# -*- coding: utf-8 -*-
<%inherit file="base.mako"/>
<%block name="header">
<h1>${_('Are you Absoutely sure to delete this Program?')}</h1>
</%block>
<%block name="content">
<%
base_url = request.route_path('home')
%>
<div class="container">
  <form method="post" action="" class="form-horizontal">
    <div class="form-group">
      <p>This action CANNOT be undone. This will permanently delete the "${program.name}" program.</p>
      <hr />
      <input type="text" class="form-control" id="id_name" name="name" value="Please type the name of the Program to confirm"
      placeholder="${_('Program Name')}" />
    </div>
    <div class="form-group">
      % if program:
      <input type="submit" class="btn btn-danger" value="${_('I understand the consequences, delete this program.')}" id="id_submit" name="form.submitted"/>
      % endif
      <a class="btn btn-success" href="${request.route_path('programs')}">${_('Cancel')}</a>
    </div>
  </form>
</div>
</%block>
