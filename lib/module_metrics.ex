defmodule Metrex.ModuleMetrics do

  use Prometheus.Metric

  @type metric_definition() :: {atom(), atom(), list()}

  @doc """
  Define an in-module prometheus metric.
  """
  defmacro defmetric(name, type, opts \\ [])
  defmacro defmetric(name, :counter, opts) do
    help_doc = Keyword.get(opts, :help, "Increment counter #{name} by 1.")
    func_name = "inc_#{name}" |> String.to_atom()
    labels = Keyword.get(opts, :labels, []) 
    label_list = Enum.map(labels, &Macro.var(&1, nil))
    quote do
      @metric_definitions {unquote(name), :counter, unquote(opts)}

      @doc """
      #{unquote(help_doc)}
      
      Generated for counter '#{unquote(name)}'.
      """
      def unquote(func_name)(unquote_splicing(label_list)) do
        Metrex.increment_counter(unquote(name), [unquote_splicing(label_list)])
      end

    end
  end

  defmacro defmetric(name, :histogram, opts) do
    help_doc = Keyword.get(opts, :help, "Observe a value for histogram #{name}.")
    func_name = "observe_#{name}" |> String.to_atom()
    labels = Keyword.get(opts, :labels, []) 
    label_list = Enum.map(labels, &Macro.var(&1, nil))
    arg_list = Enum.map(labels ++ [:observed_value], &Macro.var(&1, nil))
    quote do
      @metric_definitions {unquote(name), :histogram, unquote(opts)}

      @doc """
      #{unquote(help_doc)}
      
      Generated for histogram '#{unquote(name)}'.
      """
      def unquote(func_name)(unquote_splicing(label_list), var!(observed_var)) do
        Metrex.observe_histogram(unquote(name), [unquote_splicing(label_list)], var!(observed_var))
      end

    end
  end

  @doc """
  Initializes a metric given a metric spec.
  """
  def initialize_metric(metric_definition)
  def initialize_metric({name, :counter, opts}) do
    Counter.declare(Keyword.put(opts, :name, name))
  end

  def initialize_metric({name, :histogram, opts}) do
    Histogram.new(Keyword.put(opts, :name, name))
  end

end
