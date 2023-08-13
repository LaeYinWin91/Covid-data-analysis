select *
from [Portfolio project].dbo.Coviddeaths
order by 3,4

--select *
--from [Portfolio project].dbo.covidvaccinations
--order by 3,4

select Location, date, total_cases, new_cases, total_deaths, population
from [Portfolio project].dbo.Coviddeaths
order by 1,2

select location, date, total_cases, total_deaths, (cast(total_deaths as float))/ cast(total_cases as float)*100 as deathpercentage
from [Portfolio project].dbo.Coviddeaths 
where location like '%Myanmar%'
order by 1,2



select location, date, total_cases, population, (cast(total_cases as float))/ population*100 as Percentpopulationinfected
from [Portfolio project].dbo.Coviddeaths 
where location like '%Myanmar%'
order by 1,2

select location, max(total_cases) as HighestInfectionCount, population, max(cast(total_cases as float))/ population*100 as percentpopulationinfected
from [Portfolio project].dbo.Coviddeaths 
group by location, population
order by percentpopulationinfected desc


select location, max(cast(total_deaths as int)) as TotalDeathCount
from [Portfolio project].dbo.Coviddeaths 
where continent is not NULL
group by location
order by TotalDeathCount desc

select continent, max(cast(total_deaths as int)) as TotalDeathCount
from [Portfolio project].dbo.Coviddeaths 
where continent is not NULL
group by continent
order by TotalDeathCount desc

select date,sum (cast (total_cases as float)), sum(cast (total_deaths as float)),sum(cast (total_deaths as float))/sum (cast (total_cases as float))*100 as Deathpercentage
from [Portfolio project].dbo.Coviddeaths
where continent is not NULL
group by date
order by date

select sum (cast (total_cases as float)), sum(cast (total_deaths as float)),sum(cast (total_deaths as float))/sum (cast (total_cases as float))*100 as Deathpercentage
from [Portfolio project].dbo.Coviddeaths
where continent is not NULL
--group by date
order by 1,2


With PopVsVac (date, continent,location, population, new_vaccinations, RollingPeopleVaccinated)
as 
(
select dea.date, dea.continent, dea.location,dea.population, vac.new_vaccinations, Sum(cast(vac.new_vaccinations as bigint))
over(partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from [Portfolio project]..coviddeaths dea
Join [Portfolio project]..covidvaccinations vac
On dea.location = vac.location
and dea.date= vac.date
where dea.continent is not NULL
)
Select *, (RollingPeopleVaccinated/population) *100
From PopVsVac

Drop table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population float,
New_vaccinations numeric,
RollingPoepleVaccinated numeric
)
insert into #PercentPopulationVaccinated(date, continent, location, population, New_vaccinations, RollingPoepleVaccinated)
select dea.date , dea.continent, dea.location,dea.population, vac.new_vaccinations, Sum(cast(vac.new_vaccinations as bigint))
over(partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from [Portfolio project]..coviddeaths dea
Join [Portfolio project]..covidvaccinations vac
On dea.location = vac.location
and dea.date= vac.date
where dea.continent is not NULL

Select *
From #PercentPopulationVaccinated


Create View PercentPopulationVaccinated as
select dea.date , dea.continent, dea.location,dea.population, vac.new_vaccinations, Sum(cast(vac.new_vaccinations as bigint))
over(partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from [Portfolio project]..coviddeaths dea
Join [Portfolio project]..covidvaccinations vac
On dea.location = vac.location
and dea.date= vac.date
where dea.continent is not NULL

Select *
From PercentPopulationVaccinated