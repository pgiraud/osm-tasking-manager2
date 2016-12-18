# -*- coding: utf-8 -*-
<%inherit file="base.mako"/>
<%block name="header">
<h1>${_('Edit Label')}</h1>
</%block>
<%block name="content">
<div class="container">
    <form method="post" action="" class="">
        <div class="form-group">
          <input type="text" class="form-control" id="id_name" name="name" value="${label.name if label else ''}"
                   placeholder="${_('New label name...')}" />
        </div>
        <div class="form-group">
          <select class="colorselector" name="color">
            % for color in [u'#b60205', u'#d93f0b', u'#fbca04', u'#0e8a16', '#006b75', '#1d76db', '#0052cc', '#5319e7']:
              <option value="${color}"
                      data-color="${color}"
                      ${'selected' if label is not None and label.color == color else ''}>
                ${color}
              </option>
            % endfor
          </select>
        </div>
        % if label:
        <button type="submit" class="btn btn-success" id="id_submit" name="form.submitted">${_('Save the modifications')}</button>
        <a class="btn btn-danger" id="delete" href="${request.route_path('label_delete', label=label.id)}">${_('Delete')}</a>
        % else:
        <button type="submit" class="btn btn-success" id="id_submit" name="form.submitted">${_('Create label')}</button>
        % endif
        <a class="btn btn-default" href="${request.route_path('labels')}">${_('Cancel')}</a>
    </form>
</div>
<script>
    $('#delete').click(function() {
        if (confirm("${_('Are you sure you want to delete this label?')}")) {
            window.location = this.href;
        }
        return false;
    });
    $('.colorselector').colorselector();
</script>
</%block>

<%block name="extrascripts">
<link rel="stylesheet" href="${request.static_url('osmtm:static/js/lib/colorselector/lib/bootstrap-colorselector-0.2.0/css/bootstrap-colorselector.css')}">
<script src="${request.static_url('osmtm:static/js/lib/colorselector/lib/bootstrap-colorselector-0.2.0/js/bootstrap-colorselector.js')}"></script>
</%block>
