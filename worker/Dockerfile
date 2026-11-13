FROM mcr.microsoft.com/dotnet/sdk:7.0-alpine AS build

WORKDIR /usr/src/app

# dpendances(cache)
COPY Worker.csproj ./
RUN --mount=type=cache,target=/root/.nuget/packages \
    dotnet restore

COPY . .
RUN --mount=type=cache,target=/root/.nuget/packages \
    dotnet publish -c release --self-contained false --no-restore -o /usr/src/app/publish

# runtime seul
FROM mcr.microsoft.com/dotnet/runtime:7.0-alpine

WORKDIR /usr/src/app

# user non root
RUN adduser -D app
USER app

COPY --from=build --chown=app:app /usr/src/app/publish .

CMD ["dotnet", "Worker.dll"]
