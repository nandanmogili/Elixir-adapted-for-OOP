defmodule Animal do
  # Abstract behavior — requires a speak function
  def start(name) do
    spawn_link(fn -> loop(name) end)
  end

  defp loop(name) do
    receive do
      {:get_name, caller} ->
        send(caller, {:name, name})
        loop(name)

      {:speak, caller} ->
        send(caller, {:error, :abstract_method})
        loop(name)
    end
  end
end

defmodule Dog do
  def start(name) do
    spawn_link(fn -> loop(name) end)
  end

  defp loop(name) do
    receive do
      {:get_name, caller} ->
        send(caller, {:name, name})
        loop(name)

      {:speak, caller} ->
        send(caller, {:speak, "#{name} says: Woof!"})
        loop(name)
    end
  end
end

defmodule Cat do
  def start(name) do
    spawn_link(fn -> loop(name) end)
  end

  defp loop(name) do
    receive do
      {:get_name, caller} ->
        send(caller, {:name, name})
        loop(name)

      {:speak, caller} ->
        send(caller, {:speak, "#{name} says: Meow!"})
        loop(name)
    end
  end
end

defmodule Main do
  def run do
    dog = Dog.start("Rex")
    cat = Cat.start("Whiskers")

    send(dog, {:speak, self()})
    send(cat, {:speak, self()})

    receive_speak()
    receive_speak()
  end

  defp receive_speak do
    receive do
      {:speak, message} -> IO.puts(message)
      {:error, :abstract_method} -> IO.puts("Called abstract method!")
    end
  end
end

Main.run()
