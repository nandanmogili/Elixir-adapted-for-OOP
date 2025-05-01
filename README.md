# 🐾 Object-Oriented Principles in Elixir (via Processes)

This project is a functional re-imagining of traditional object-oriented programming (OOP) using **Elixir**, a functional, concurrent language built on the Erlang VM.

It emulates OOP constructs such as:
- **Encapsulation**
- **Abstraction**
- **Inheritance**
- **Polymorphism**

All of this is achieved using **processes**, **message passing**, and **pattern matching**, without relying on Elixir modules like `GenServer` or any object/class system.

---

## Context

This Elixir implementation mirrors the behavior of a Java program with an abstract `Animal` class and two subclasses `Dog` and `Cat`, each overriding the `speak()` method.

### Java Analogy:
```java
Animal a1 = new Dog("Rex");
Animal a2 = new Cat("Whiskers");

a1.speak();  // Rex says: Woof!
a2.speak();  // Whiskers says: Meow!
```

### In Elixir:
Each "object" is a **process**. We send messages like `:speak` to a process, and the process responds according to its type (Dog or Cat). Thus, behavior is polymorphic.

---

## Discussion Question and Implementation

### Encapsulation
Each animal's state (e.g. its `name`) is stored inside a process. The only way to interact with this state is by sending messages to that process. External modules cannot directly access the internal data.

### Abstraction
The `Animal` module defines a basic loop for receiving messages, but the `:speak` behavior is intentionally unimplemented—simulating an abstract method. Calling it returns an error, just like calling an abstract method in Java.

### Inheritance (Simulated)
While Elixir doesn’t support classical inheritance, the shared logic for responding to messages (like `:get_name`) is reused across modules (`Animal`, `Dog`, `Cat`). Specialization is done by writing separate modules with customized behavior.

### Polymorphism
All animals respond to the same message interface (e.g., `:speak`, `:get_name`). Despite this uniform interface, the response depends on the specific type (dog or cat), just like polymorphism in Java.

---


##  How It Works

### `Animal` Module (Abstract Behavior)

```elixir
defmodule Animal do
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
```

- Starts a process storing the `name`.
- Responds to `:get_name` but returns an error for `:speak` — acting as an "abstract class".

---

### `Dog` Module

```elixir
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
```

- Implements `:speak` message with a dog-specific message.

---

### `Cat` Module

```elixir
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
```

- Similar to `Dog`, but with cat behavior in `:speak`.

---

### `Main` Module (Driver Program)

```elixir
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
```

- Spawns dog and cat processes.
- Sends each a `:speak` message.
- Waits to receive their responses.
- Demonstrates **polymorphic dispatch**.

---

## How to Run

### 1. Save the script

Save the Elixir code in a file called:

```bash
animal_objects.exs
```

### 2. Run the script

```bash
elixir animal_objects.exs
```

### Expected Output

```bash
Rex says: Woof!
Whiskers says: Meow!
```

---

## Summary Table of OO Concepts in Elixir

| OOP Pillar      | Java                         | Elixir Equivalent                                  |
|------------------|------------------------------|----------------------------------------------------|
| **Encapsulation** | `private String name`         | Process-local state, accessed via messages         |
| **Abstraction**   | `abstract void speak()`       | Default `:speak` handler in `Animal` returns error |
| **Inheritance**   | `extends Animal`              | Reused message patterns & process templates        |
| **Polymorphism**  | `animal.speak()`              | Same message, different response per module        |

---

## Author

**Nandan Mogili**

