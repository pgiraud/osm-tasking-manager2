# -*- coding: utf-8 -*-
<%namespace file="custom.mako" name="custom"/>
<%inherit file="base.mako"/>
<%block name="header">
</%block>
<%block name="content">
<div class="container">
  <div class="col-md-6">
    ${custom.main_page_right_panel()}
  </div>
  <div class="text-center">
    <h1></h1>
    <a class="btn btn-lg btn-primary"
        href="${request.route_url('projects')}">
      <i class="glyphicon glyphicon-share-alt"></i>
      Go to projects list</a>
  </div>
</div>
</%block>
