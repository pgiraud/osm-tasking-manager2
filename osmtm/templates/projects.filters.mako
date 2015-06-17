<%
  sorts = [('priority', 'asc', _('High priority first')),
           ('created', 'desc', _('Creation date')),
           ('last_update', 'desc', _('Last update'))]
  qs = dict(request.GET)

  sort_by = qs.get('sort_by', 'priority')
  direction = qs.get('direction', 'asc')
  button_text = ''
  for sort in sorts:
      if sort[0] == sort_by and sort[1] == direction:
          button_text = sort[2]
  endfor
%>
<form class="form-inline" role="form"
      action="${request.current_route_url()}"
      method="GET">

  <div class="row">
    <div class="col-md-12">
      <input type="hidden" name="sort_by"
             value="${request.params.get('sort_by', 'priority')}">
      <input type="hidden" name="direction"
             value="${request.params.get('direction', 'asc')}">

      <div class="form-group left-inner-addon">
        <i class="glyphicon glyphicon-search text-muted"></i>
        <input type="search" class="form-control input-sm"
               name="search" placeholder="${_('Search')}"
               value="${request.params.get('search', '')}">
      </div>
      <div class="btn-group pull-right">
        <button type="button" class="btn btn-default btn-sm dropdown-toggle"
                data-toggle="dropdown">
          ${_('Sort by:')} <strong>${button_text}</strong>
          <span class="caret"></span>
        </button>
        <ul class="dropdown-menu" role="menu">
          % for sort in sorts:
            <%
              qs['sort_by'] = sort[0]
              qs['direction'] = sort[1]
            %>
            <li>
              <a href="${request.current_route_url(_query=qs.items())}">
                ${sort[2]}
              </a>
            </li>
          % endfor
        </ul>
      </div>
    </div>
  </div>
  <div class="row">
    <div class="col-md-12">
      % if user and user.username:
      <div class="checkbox input-sm pull-right">
        <label>
          <input type="checkbox" name="my_projects"
            ${'checked' if request.params.get('my_projects') == 'on' else ''}
            onclick="this.form.submit();"> ${_('Your projects')}
        </label>
      </div>
      % else:
      <br>
      % endif
    </div>
  </div>
</form>
