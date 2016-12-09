# -*- coding: utf-8 -*-
<%inherit file="base.mako"/>
<%block name="header">
<h1>${_('Edit Label')}</h1>
</%block>
<%block name="content">
<div class="container">
    <form method="post" action="" class="form-inline">
        <div class="form-group">
          <input type="text" class="form-control" id="id_name" name="name" value="${label.name if label else ''}"
                 placeholder="${_('New label name...')}" />
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
</script>
</%block>
