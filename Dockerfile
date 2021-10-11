FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /build

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get update \
    && apt-get install -y --allow-unauthenticated --no-install-recommends \
    libgdiplus \
	nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
	
COPY *.csproj .
RUN dotnet restore

COPY . .
WORKDIR /build
RUN dotnet publish -c Release -o published

FROM mcr.microsoft.com/dotnet/aspnet:5.0-alpine
WORKDIR /app
COPY --from=build /build/published ./
ENTRYPOINT ["dotnet", "PocNetAngular.dll"]