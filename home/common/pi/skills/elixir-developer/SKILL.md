---
name: elixir-developer
description: A senior developer that writes elixir code, use the skill when working with elixir project
metadata:
  author: Yucheng CAO
  version: "0.1"
---

# General coding
- Don't add decorative section separator comments like `# ── Section Name ──────`. The code structure should speak for itself through `@moduledoc`, `@doc`, and function grouping.
- If the variable(binding) isn't used, prefer chaining using pipe operator.
<good-example>

```elixir
a = 1
c = a |> double() |> triple()
```
</good-example>

<bad-example>
```elixir
# a is not used by c
a = 1
b = double(a)
c = triple(b)
```
</bad-example>

- separate the query from the `Repo` operation
  <good-example>
 ```elixir
    query =
      from s in EpisodeStream,
        where: s.episode_id == ^content_id and is_nil(s.image_owner_id)

    streams = Repo.one(query)
 ``` 
  </good-example>

  <bad-example>
 ```elixir
    streams = Repo.one(from (s in EpisodeStream,
        where: s.episode_id == ^content_id and is_nil(s.image_owner_id)))
 ``` 
  </bad-example>

- Enforce data shape at the boundary (controller params, Oban job args). Don't write dual-key access (`map[:key] || map["key"]`) inside business logic — if you're unsure which key format arrives, fix the caller or add explicit conversion at the entry point. Similarly, avoid unnecessary fallback defaults like `|| []`, `|| ""`, `|| %{}` when the data shape is already guaranteed by the boundary. Pattern match or validate once at the entry point; trust the shape downstream.

<bad-example>
```elixir
# Defensive dual-key access deep in business logic
def update_rating(_, content_id, rating) when is_map(rating) do
  value = rating[:value] || rating["value"]
  descriptors = rating[:descriptors] || rating["descriptors"] || []
  # ...
end
```
</bad-example>

<good-example>
```elixir
# Enforce shape at the boundary (controller/params module), then trust it
def update_rating(_, content_id, %{value: value, descriptors: descriptors}) do
  # value and descriptors are guaranteed atom-keyed by the caller
  # ...
end
```
</good-example>

- Write assertive code: use pattern matching in function heads instead of defensive validation with case/if. Let non-matching inputs raise (FunctionClauseError) rather than manually returning error tuples.

<good-example>
```elixir
# Pattern match directly in the function head — invalid input raises FunctionClauseError
def parse_xml_from_s3(conn, %{"s3_path" => "s3://" <> _ = s3_path}) do
  conn
  |> put_status(200)
  |> json(%{success: true, values: [stub_episode_avail(s3_path)], warns: []})
end
```
</good-example>

<bad-example>
```elixir
# Defensive validation with case/if — unnecessarily verbose
def parse_xml_from_s3(conn, %{"s3_path" => s3_path}) do
  case validate_s3_path(s3_path) do
    :ok ->
      conn
      |> put_status(200)
      |> json(%{success: true, values: [stub_episode_avail(s3_path)], warns: []})

    {:error, reason} ->
      conn
      |> put_status(400)
      |> json(%{success: false, error: reason})
  end
end

def parse_xml_from_s3(conn, _params) do
  conn
  |> put_status(400)
  |> json(%{success: false, error: "Missing required parameter: s3_path"})
end

defp validate_s3_path(s3_path) do
  if String.starts_with?(s3_path, "s3://"), do: :ok, else: {:error, "Invalid S3 path"}
end
```
</bad-example>

- Use `Repo.transact` instead of `Repo.transaction`. `transact` expects the function to return `{:ok, result}` or `{:error, reason}` directly — no `Repo.rollback` needed. The transaction commits on `{:ok, _}` and rolls back on `{:error, _}`.

<good-example>
```elixir
Repo.transact(fn ->
  with {:ok, record} <- do_something(),
       {:ok, updated} <- do_another(record) do
    {:ok, updated}
  end
end)
```
</good-example>

<bad-example>
```elixir
Repo.transaction(fn ->
  record = do_something!()
  case do_another(record) do
    {:ok, updated} -> updated
    {:error, reason} -> Repo.rollback(reason)
  end
end)
```
</bad-example>

- Use a `query` variable and pass it to `Repo`, even for simple queries. Do not inline `from(...)` inside `Repo.all(from(...))` or pipe `|> Repo.one()`.

<good-example>
```elixir
query =
  from i in ModerationIssue,
    where: i.moderation_record_id == ^record_id and is_nil(i.reviewed_at)

issues = Repo.all(query)
```
</good-example>

<bad-example>
```elixir
issues =
  from(i in ModerationIssue,
    where: i.moderation_record_id == ^record_id and is_nil(i.reviewed_at)
  )
  |> Repo.all()
```
</bad-example>

# Before finishing
- Run `mix test` in the project directory and fix all test failures before committing.
- Run `mix compile` in the project directory and fix all warnings before committing (the project may use `--warnings-as-errors`).
- Run `mix credo` in the project directory and fix all warnings before committing.
- Always run `mix format` in the project directory before committing Elixir changes.

# Testing instructions
- Always prefer pattern matching over equality in assertion

<bad-example>
```elixir
  poster_asset = Enum.find(movie_with_assets.asset_images, &(&1.type == :poster))
  assert poster_asset != nil
```
</bad-example>

<good-example>
```elixir
assert %ContentAvail.Asset.Image{} = poster_asset = Enum.find(movie_with_assets.asset_images, &(&1.type == :poster))
```
</good-example>

- Assert multiple fields from a response using a single pattern match, not by extracting into a variable then asserting each field separately

<good-example>
```elixir
assert %{
         "values" => [
           %{
             "video_file_path" => "first_game.mp4",
             "thumbnail_file_path" => "first_game.jpg",
             "subtitle_file_path" => "first_game.srt"
           }
         ]
       } =
         conn
         |> post("/api/parse_xml_from_s3", %{s3_path: "s3://bucket/first_game.xml"})
         |> json_response(200)
```
</good-example>

<bad-example>
```elixir
%{"values" => [avail]} =
  conn
  |> post("/api/parse_xml_from_s3", %{s3_path: "s3://bucket/first_game.xml"})
  |> json_response(200)

assert "first_game.mp4" = avail["video_file_path"]
assert "first_game.jpg" = avail["thumbnail_file_path"]
assert "first_game.srt" = avail["subtitle_file_path"]
```
</bad-example>
