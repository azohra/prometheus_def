defmodule PrometheusDef do
  @moduledoc """
  Documentation for PrometheusDef.
  """

  use Prometheus

  @doc false
  defmacro __using__(_opts \\ []) do
    quote do
      import PrometheusDef.ModuleMetrics, only: [defmetric: 3]
      Module.register_attribute(__MODULE__, :metric_definitions, accumulate: true)
      @before_compile PrometheusDef
    end
  end

  @doc false
  defmacro __before_compile__(_opts) do
    quote do

      def setup_metrics() do
        @metric_definitions
        |> Enum.each(&(PrometheusDef.ModuleMetrics.initialize_metric(&1)))
      end

    end
  end

  @doc """
  Initialize metrics defined in modules.
  """
  def setup(modules) do
    modules
    |> Enum.each(&apply(&1, :setup_metrics, []))
  end

  @doc """
  Increment a counter metric.
  """
  def increment_counter(name, labels),
    do: Counter.inc([name: name,
                     labels: labels])

  @doc """
  Observe a histogram value.
  """
  def observe_histogram(name, labels, value),
    do: Histogram.observe([name: name,
                           labels: labels], value)

end
