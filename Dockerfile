# Build Stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

COPY . .
RUN dotnet restore devops-api.sln
RUN dotnet publish devops-api.sln -c Release -o /app/publish
# RUN dotnet restore
# RUN dotnet publish -c Release -o /app/publish

# Runtime Stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app

# create non-root user
RUN addgroup --system appgroup && adduser --system --ingroup appgroup infinionuser

COPY --from=build /app/publish .

# # switch to non-root
# USER infinionuser
EXPOSE 80
ENV ASPNETCORE_URLS=http://0.0.0.0:80
USER infinionuser
ENTRYPOINT ["dotnet", "InfinionDevOps.dll"]