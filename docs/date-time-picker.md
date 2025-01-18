# Date Time Picker

## Form

You can pick dates with time using the xdan's [jQuery Plugin Date and Time Picker](https://github.com/xdan/datetimepicker)

```ruby
form do |f|
  f.inputs "Details" do
    f.input :updated_at, as: :date_time_picker
  end

  f.actions
```

<img src="./images/date-time-picker.gif" height="280" />

## Options

You can pass to `picker_options`, all the options available on xdan's library. Notice `timepicker: false` to only show a date picker

```ruby
form do |f|
  f.inputs "Details" do
    f.input :updated_at, as: :date_time_picker,
                         picker_options: {
                           min_date: Date.current - 2.days,
                           allow_times: [
                             '12:10', '13:10', '15:10',
                             '17:10', '18:10', '19:10'
                           ],
                           timepicker: false
                         }
  end

  f.actions
```

You can also pass `input_format` to set DateTimePickerInput input format that should be expected from the backend. This option also be set globally in the options below.

## Overriding defaults

You can modify, in the gem's setup block, the default options like this:

```ruby
ActiveadminAddons.setup do |config|
  # Set default options for DateTimePickerInput. The options you can provide are the same as in
  # xdan's datetimepicker library (https://github.com/xdan/datetimepicker/tree/2.5.4). You need to
  # pass a ruby hash, avoid camelCase keys. For example: use min_date instead of minDate key.
  config.datetime_picker_default_options = {
    format: "d-m-Y H:i",
    step: 10 # minutes
  }

  # Set DateTimePickerInput input format. This if for backend (Ruby)
  config.datetime_picker_input_format = "%d-%m-%Y %H:%M"
end
```
