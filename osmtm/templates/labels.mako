# -*- coding: utf-8 -*-
<%inherit file="base.mako"/>
<%block name="header">
<h1>${_('Labels')}</h1>
</%block>
<%block name="content">
<div class="container group wrap">
    <div class="row">
        <div class="col-md-6">
            <ul class="list-unstyled list-underline">
              % for label in labels:
              <li class="clear">
                  <%
                    import re
                    label_id = label.name
                    if re.findall(ur'\s', label_id):
                      label_id = '\"' + label_id + '\"'
                  %>
                  <a class="btn btn-default"
                     style="background-color: ${label.color}; color:white;"
                     href="${request.route_url('home', _query={'search': 'label:' + label_id})}">
                     ${label.name}
                  </a>
                  <a href="${request.route_path('label_edit', label=label.id)}" class="btn pull-right">${_('edit')}</a><br />
              </li>
              % endfor
            </ul>
        </div>
        <div class="col-md-6">
            <a href="${request.route_path('label_new')}" class="btn btn-default btn-success">${_('New label')}</a>
        </div>
    </div>
</div>
</%block>
