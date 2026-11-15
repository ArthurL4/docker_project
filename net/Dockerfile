#BUILD MUTLI-STAGE
#Je récup déjà le sdk pour pouvoir build l'app
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build

WORKDIR /build/net

COPY ./worker .

RUN dotnet restore
RUN dotnet publish -c release --self-contained false --no-restore -o ./target


#Je lance l'app en récupérant le build que j'ai stocké dans /target au-dessus (java -ref, plus simple pour moi) (voir pour faire avec python et uv)
FROM mcr.microsoft.com/dotnet/aspnet:7.0

RUN adduser --system --shell /usr/sbin/nologin --group --no-create-home app

USER app 

WORKDIR /app/net/

COPY --chown=app:app --from=build /build/net/target/ /app/net/

ENTRYPOINT [ "dotnet" ]

CMD ["Worker.dll"]