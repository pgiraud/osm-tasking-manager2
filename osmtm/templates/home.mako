# -*- coding: utf-8 -*-
<%inherit file="base.mako"/>
<%block name="header">
</%block>
<%block name="content">
<%
sorts = [('priority', 'asc', _('High priority first')),
         ('created', 'desc', _('Creation date')),
         ('last_update', 'desc', _('Last update'))]
%>
% if user:
  <%include file="home.loggedin.mako" />
% else:
  <%include file="home.anonymous.mako" />
% endif
</%block>
