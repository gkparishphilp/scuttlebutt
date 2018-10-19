#= require pulitzer/plugins/froala/js/froala_editor
#= require pulitzer/plugins/froala/js/plugins/align
#= require pulitzer/plugins/froala/js/plugins/char_counter
#= require pulitzer/plugins/froala/js/plugins/code_view
#= require pulitzer/plugins/froala/js/plugins/code_beautifier
#= require pulitzer/plugins/froala/js/plugins/colors
#= require pulitzer/plugins/froala/js/plugins/font_size
#= require pulitzer/plugins/froala/js/plugins/image
#= require pulitzer/plugins/froala/js/plugins/link
#= require pulitzer/plugins/froala/js/plugins/lists
#= require pulitzer/plugins/froala/js/plugins/paragraph_format
#= require pulitzer/plugins/froala/js/plugins/quote
#= require pulitzer/plugins/froala/js/plugins/table
#= require pulitzer/plugins/froala/js/plugins/url
#= require pulitzer/plugins/froala/js/plugins/video

init_wysiwyg = (container)->

	try

		default_wysiwyg_toolbar_button_presets =
		{
			comment: ['bold', 'italic','insertLink', 'insertImage', 'clearFormatting'],
			default: ['bold', 'italic','insertLink', 'insertImage', 'clearFormatting', 'undo', 'redo'],
		}

		$('textarea.wysiwyg', container).each ->
			$this = $(this)

			config = ($this.data('wysiwyg') || {})
			config.toolbar_sticky = config.toolbar_sticky || false
			config.char_counter_count = config.char_counter_count || false

			toolbar_preset = config.toolbar_preset || 'default'

			config.image_upload_params = (config.image_upload_params || { attribute: (config.attachment_attribute || 'embedded_attachments'), object_class: config.object_class, object_id: config.object_id })
			config.image_upload_params[$('meta[name=csrf-param]').attr('content')] = $('meta[name=csrf-token]').attr('content')
			config.image_upload_method = config.image_upload_method || 'POST'

			wysiwyg_toolbar_buttons = config.toolbar_buttons || default_wysiwyg_toolbar_button_presets[toolbar_preset] || default_wysiwyg_toolbar_button_presets['default']
			wysiwyg_toolbar_buttons_md = config.toolbar_buttons_md || default_wysiwyg_toolbar_button_presets[toolbar_preset+"_md"] || wysiwyg_toolbar_buttons
			wysiwyg_toolbar_buttons_sm = config.toolbar_buttons_sm || default_wysiwyg_toolbar_button_presets[toolbar_preset+"_sm"] || wysiwyg_toolbar_buttons_md
			wysiwyg_toolbar_buttons_xs = config.toolbar_buttons_xs || default_wysiwyg_toolbar_button_presets[toolbar_preset+"_xs"] || wysiwyg_toolbar_buttons_sm

			$this.froalaEditor({
				heightMin: $this.data('heightmin') || config.height_min,
				linkInsertButtons: ['linkBack'],
				linkList: false,
				linkMultipleStyles: false,
				toolbarInline: false,
				pastePlain: true,
				charCounterCount: config.char_counter_count,
				placeholderText: $this.attr('placeholder'),
				height: $this.data('height'),
				toolbarSticky: config.toolbar_sticky,
				toolbarStickyOffset: config.toolbar_sticky_offset || $('header>nav').outerHeight(),
				imageUploadParam: (config.image_upload_param || 'attachments'),
				imageUploadParams: config.image_upload_params,
				imageUploadURL: (config.image_upload_url || '/attachments'),
				imageUploadMethod: config.image_upload_method,
				toolbarButtons: wysiwyg_toolbar_buttons,
				toolbarButtonsMD: wysiwyg_toolbar_buttons_md,
				toolbarButtonsSM: wysiwyg_toolbar_buttons_sm,
				toolbarButtonsXS: wysiwyg_toolbar_buttons_xs,
				zIndex: ($this.data('wysiwyg') || {}).z_index,
			})
			$this.froalaEditor('events.focus') if $this.attr('autofocus')
		$('textarea.wysiwyg-inline', container).each ->
			$this = $(this)

			config = ($this.data('wysiwyg') || {})
			config.toolbar_sticky = config.toolbar_sticky || false
			config.char_counter_count = config.char_counter_count || false

			toolbar_preset = config.toolbar_preset || 'default'

			config.image_upload_params = (config.image_upload_params || { attribute: (config.attachment_attribute || 'embedded_attachments'), object_class: config.object_class, object_id: config.object_id })
			config.image_upload_params[$('meta[name=csrf-param]').attr('content')] = $('meta[name=csrf-token]').attr('content')
			config.image_upload_method = config.image_upload_method || 'POST'

			wysiwyg_toolbar_buttons = config.toolbar_buttons || default_wysiwyg_toolbar_button_presets[toolbar_preset] || default_wysiwyg_toolbar_button_presets['default']
			wysiwyg_toolbar_buttons_md = config.toolbar_buttons_md || default_wysiwyg_toolbar_button_presets[toolbar_preset+"_md"] || wysiwyg_toolbar_buttons
			wysiwyg_toolbar_buttons_sm = config.toolbar_buttons_sm || default_wysiwyg_toolbar_button_presets[toolbar_preset+"_sm"] || wysiwyg_toolbar_buttons_md
			wysiwyg_toolbar_buttons_xs = config.toolbar_buttons_xs || default_wysiwyg_toolbar_button_presets[toolbar_preset+"_xs"] || wysiwyg_toolbar_buttons_sm

			$this.froalaEditor({
				heightMin: $this.data('heightmin') || config.height_min,
				linkInsertButtons: ['linkBack'],
				linkList: false,
				linkMultipleStyles: false,
				toolbarInline: true,
				pastePlain: true,
				charCounterCount: config.char_counter_count || false,
				toolbarContainer: config.toolbar_container || null,
				toolbarVisibleWithoutSelection: config.toolbar_visible_without_selection || false,
				toolbarButtons: wysiwyg_toolbar_buttons,
				toolbarButtonsMD: wysiwyg_toolbar_buttons_md,
				toolbarButtonsSM: wysiwyg_toolbar_buttons_sm,
				toolbarButtonsXS: wysiwyg_toolbar_buttons_xs,
				height: $this.data('height'),
				placeholderText: $this.attr('placeholder'),
				#toolbarSticky: false,
				imageUploadParam: (config.image_upload_param || 'attachments'),
				imageUploadParams: config.image_upload_params,
				imageUploadURL: (config.image_upload_url || '/attachments'),
			})
			$this.froalaEditor('events.focus') if $this.attr('autofocus')
	catch e
		console.log('wysiwyg editor', e)




$(document).ready ()->
	$(document).trigger('ready')
$(document).on 'ready', (e)->
	init_wysiwyg( $(e.target) )
$(document).on 'new-content', (e)->
	init_wysiwyg( $(e.target) )
