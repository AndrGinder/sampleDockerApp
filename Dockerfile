FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG token
WORKDIR /src

COPY ["src/Web/sampleDockerApp.Web.csproj", "sampleDockerApp.Web/"]
COPY ["src/EFContext/sampleDockerApp.EFContext.csproj", "sampleDockerApp.EFContext/"]

RUN dotnet restore "sampleDockerApp.Web/sampleDockerApp.Web.csproj"

COPY . .
WORKDIR /src/sampleDockerApp.Web

RUN dotnet build -c Release -o /app/build

FROM build AS publish
RUN dotnet publish -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "sampleDockerApp.Web.dll"]