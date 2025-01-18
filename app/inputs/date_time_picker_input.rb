# The MIT License (MIT)
#
# Copyright (c) 2015 Igor Fedoronchuk
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

class DateTimePickerInput < ActiveAdminAddons::InputBase
  def load_control_attributes
    load_class(@options[:class])
    load_data_attr(:picker_options, value: datetime_picker_options)
    load_attr(:maxlength, value: 19)
    load_attr(:autocomplete, value: 'off')
    load_attr(:value, value: formatted_input_value)
  end

  def formatted_input_value
    v = input_value

    if v.is_a?(Time)
      return DateTime.new(v.year, v.month, v.day, v.hour, v.min, v.sec).strftime(
        options[:input_format] || ActiveadminAddons.datetime_picker_input_format
      )
    end

    v.to_s
  end

  def datetime_picker_options
    @datetime_picker_options ||= begin
      opts = default_picker_options.merge(options.fetch(:picker_options, {}))
      Hash[opts.map { |k, v| [k.to_s.camelcase(:lower), v] }]
    end
  end

  protected

  def default_picker_options
    res = ActiveadminAddons.datetime_picker_default_options.map do |k, v|
      if v.respond_to?(:call) || v.is_a?(Proc)
        [k, v.call]
      else
        [k, v]
      end
    end
    Hash[res]
  end
end
