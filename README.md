# prometheus_def

A quality of life upgrade when working with prometheus metrics.

## Installation

First add as a dependency as usual...

```elixir
def deps do
  [
    {:prometheus_def, "~> 0.0.0-alpha.1"}
  ]
end
```

Add the initializer to application startup.

``` elixir
defmodule MyApp.Application do
  use Application
  
  def start(_type, _args) do
  PrometheusDef.setup([
    # List modules using defmetric to initialize the metrics
    MyApp.MyModule
  ])
  # ....
  end
end
```

## defmacro

``` elixir
defmodule MyModule do
  use PrometheusDef

  defmetric :my_test_counter, :counter,
    help: "A test counter",
    labels: [:example_value]
    
  defmetric :my_test_histogram, :histogram,
    help: "An example histogram",
    labels: [:example_value1, :example_value2]
    
    
    
  def do_work() do
    # Depending on the metric type, an associated function will be created
    inc_my_test_counter("some example value")
    
    observed_value = 100
    # Labels are added as paramaters in the same order they are listed
    observe_my_test_histogram("a first label", "the second label", observed_value)
  end
end
```

## Documentation

Functions are documented automatically from the optional `:help` field when
defining metrics.

``` elixir
iex(1) > h MyApp.MyModule.inc_my_test_counter

  def inc_my_test_counter(test)

A test counter

Generated for counter 'my_test_counter'.

```

