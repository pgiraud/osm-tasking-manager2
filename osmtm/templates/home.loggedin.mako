<div class="container">
  <div class="row">
    <div class="col-md-8">
      <h2>Your latest mapping</h2>
      <ul>
        <li></li>
        <li></li>
        <li></li>
        <li></li>
      </ul>
    </div>
    <div class="col-md-4">
      <h2>Did you know?</h2>
    </div>
  </div>
  <div class="row">
    <div class="col-md-8">
      <%include file="projects.filters.mako" />
      <%namespace name="projects_list" file="projects.list.mako"/>
      % if projects.items:
          ${projects_list.render(projects=projects)}
      % endif
    </div>
    <div class="col-md-4">
      <h2>Have you seen these programs?</h2>
      % for program in programs:
        <div class="well">
          <h4>
            <span class="badge program"><i class="glyphicon glyphicon-briefcase"></i> Program</span>
            <a href="${request.route_path('program', program=program.id)}">${program.name}</a>
          </h4>
          <div>
            ${program.description}
          </div>
        </div>
      % endfor
    </div>
  </div>
</div>
