defmodule UserDefault do

  defmacro __using__(_opts) do
    IO.puts IEx.color(:doc_underline, """
    You are USING #{__MODULE__} from #{__DIR__}/.iex.exs
    """
    )

    quote do          # <--
      import Elixir.UserDefault, only: [modified_modules: 0]
    end
  end

  def modified_modules do
    for {m, _} <- :code.all_loaded(), do: m
  end

  def module_modified(module) do
    case :code.is_loaded(module) do
	    {:file, :preloaded} ->
	      false;
	    {:file, path} ->
	      compile_opts = :proplists.get_value(:compile, module.module_info())
	      compile_time = :proplists.get_value(:time, compile_opts)
	      src = :proplists.get_value(:source, compile_opts)
	      module_modified(path, compile_time, src)
	    _ ->
	      false
    end
  end

  def module_modified(path, prev_compile_time, prev_src) do
    case find_module_file(path) do
	    false ->
	      false;
	    mod_path ->
	      case :beam_lib.chunks(mod_path, ["CInf"]) do
		      {:ok, {_, [{_, cb}]}} ->
		        compile_opts =  :erlang.binary_to_term(cb)
		        compile_time = :proplists.get_value(:time, compile_opts)
		        src = :proplists.get_value(:source, compile_opts)
		        not (compile_time == prev_compile_time) and	(src == prev_src)
		      _ ->
		        false
	      end
    end
  end

  def find_module_file(path) do
    case :file.read_file_info(path) do
	    {:ok, _} ->
	      path;
	    _ ->
	      # may be the path was changed
	      case :code.where_is_file(:filename.basename(path)) do
		      :non_existing ->
		        false;
		      new_path ->
		        new_path
	      end
    end
  end

end
