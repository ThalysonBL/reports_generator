defmodule ReportsGenerator do
  alias ReportsGenerator.Parser

  @available_foods [
    "açaí",
    "churrasco",
    "esfirra",
    "hambúrguer",
    "pastel",
    "pizza",
    "prato_feito",
    "sushi"
  ]

  @options ["foods", "users"]
  # para definirmos uma const usamos @NOME_DA_CONST

  def build(filename) do
      filename
      |> Parser.parse_file()
      |> Enum.reduce(report_acc(), fn line, report -> sum_values(line, report) end)
  end

  def build_from_many(filenames) when not is_list(filenames), do:  {:error, "Please provide a list of strings"}

  def build_from_many(filenames) do
    result =
    filenames
    |> Task.async_stream(&build/1)
    |> Enum.reduce(report_acc(),fn {:ok, result}, report -> sum_reports(report, result) end)
    {:ok, result}

  end

  # when: se options for uma das opções do @options, vai executar
  # retorna o maior valor
  def fetch_higher_cost(report, option) when option in @options do
    {:ok, Enum.max_by(report[option], fn {_key, value} -> value end)}
  end

  # se a função acima não for correspondida, executará essa
  def fetch_higher_cost(_report, _option), do: {:error, "invalid option!"}

  defp sum_values([id, food_name, price], %{"foods" => foods, "users" => users} = _report) do
    users = Map.put(users, id, users[id] + price)
    foods = Map.put(foods, food_name, foods[food_name] + 1)

    build_report(foods, users)

  end


  defp sum_reports(%{"foods" => foods1, "users" => users1}, %{"foods" => foods2, "users" => users2}) do
    foods =  merge_maps(foods1, foods2)
    users =   merge_maps(users1, users2)
 # %{"foods" => foods, "users" => users} # foods retorna foods
    build_report(foods, users)

  end
  defp merge_maps(map1, map2) do
    Map.merge(map1, map2, fn _key, value1, value2 -> value1 + value2 end)

  end

  defp report_acc do
    foods = Enum.into(@available_foods, %{}, &{&1, 0})
    users = Enum.into(1..30, %{}, &{Integer.to_string(&1), 0})
    build_report(foods, users)
  end

  defp build_report(foods, users), do: %{"foods" => foods, "users" => users}
end

# |> Piper operator

# {:ok, file} = File.read("reports/#{filename}")

# case File.read("reports/#{filename}") do
# {:ok, result} -> result
#  {:error, reason} -> reason
## _ -> "caso qualquer"## usamos _ para ser um caso que não caia no result ou error ## PADRÃO
# end
