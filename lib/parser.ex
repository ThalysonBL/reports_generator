defmodule ReportsGenerator.Parser do
  def parse_file(filename) do
    ## Pego essa string
    "reports/#{filename}"
    ## Envio para ler o arquivo
    |> File.stream!()
    |> Stream.map(fn line -> parse_line(line) end)
  end

  ## Tratativa dos dados
  defp parse_line(line) do
    line
    # Trim retira todos os espaços do elemento
    |> String.trim()
    # split separa todos os elementos por , # definimos que será separado por virgula
    |> String.split(",")
    # atualizamos o elmento 2 da lista para to_integer com aridade 1
    |> List.update_at(2, &String.to_integer/1)

    # to_integer é transformado em number
  end
end

# |> Piper operator

# {:ok, file} = File.read("reports/#{filename}")

# case File.read("reports/#{filename}") do
# {:ok, result} -> result
#  {:error, reason} -> reason
## _ -> "caso qualquer"## usamos _ para ser um caso que não caia no result ou error ## PADRÃO
# end
