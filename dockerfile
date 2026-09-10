FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src

COPY ["src/OzonEdu.EmployeesService/OzonEdu.EmployeesService.csproj", "src/OzonEdu.EmployeesService/"]
RUN dotnet restore "src/OzonEdu.EmployeesService/OzonEdu.EmployeesService.csproj"

COPY . .

WORKDIR "/src/src/OzonEdu.EmployeesService"
RUN dotnet build "OzonEdu.EmployeesService.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "OzonEdu.EmployeesService.csproj" -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS runtime
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM runtime AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "OzonEdu.EmployeesService.dll"]