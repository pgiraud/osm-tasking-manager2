<%namespace file="custom.mako" name="custom"/>
<div class="container">
  <div class="row">
    <div class="col-md-6">
      <h2>${_('About the Tasking Manager')}</h2>
      <p>
      ${_('OSM Tasking Manager is a mapping tool designed and built for the Humanitarian OSM Team collaborative mapping. The purpose of the tool is to divide up a mapping job into smaller tasks that can be completed rapidly. It shows which areas need to be mapped and which areas need the mapping validated. <br />This approach facilitates the distribution of tasks to the various mappers in a context of emergency. It also permits to control the progress and the homogeinity of the work done (ie. Elements to cover, specific tags to use, etc.).')|n}
      </p>
      <hr />
      <p>
      ${custom.main_page_community_info()}
      </p>
    </div>
  </div>
  <div class="row">
    % for program in programs:
      <div class="col-md-4">
        <div class="well">
          <h4>
            <span class="badge program">Program</span>
            <a href="${request.route_path('program', program=program.id)}">${program.name}</a>
          </h4>
          <div>
            ${program.description}
          </div>
        </div>
      </div>
    % endfor
    <div class="col-md-12">
      <div class="well text-center">
        <a href="${request.route_path('projects')}">+ all other projects</a>
      </div>
    </div>
  </div>
</div>
