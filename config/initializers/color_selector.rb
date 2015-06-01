class ColorSelectorInput < SimpleForm::Inputs::Base
  def input
  	input_html_options[:onchange] = "changeForInput('#{input_html_options[:id]}', '#{input_html_options[:id]}_selector')"
  	input_html_options[:pattern] = "#[0-9A-Fa-f]{6}"
    field1 = @builder.input_field(:"#{attribute_name}", input_html_options)
    field2 = @builder.input_field(:"#{attribute_name}", type: :color, id: "#{input_html_options[:id]}_selector", class: "color-selector", onchange: "changeForSelector('#{input_html_options[:id]}_selector', '#{input_html_options[:id]}')" )

    (field1 << field2).html_safe
  end
end