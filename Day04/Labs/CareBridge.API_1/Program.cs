using CareBridge.EFCoreDemo.Models.Generated;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

// Register EF Core DbContext.
// ASP.NET Core will automatically create and inject it when needed.
builder.Services.AddDbContext<CareBridgeScaffoldContext>();

// Add Swagger support.
// Swagger gives us a testing screen for APIs.
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// Allow Vue.js running on another port
// to call this API from the browser.
builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(policy =>
    {
        policy.AllowAnyOrigin()
              .AllowAnyHeader()
              .AllowAnyMethod();
    });
});

var app = builder.Build();

// Enable Swagger.
app.UseSwagger();
app.UseSwaggerUI();

// Enable CORS.
app.UseCors();

// Simple health-check endpoint.
app.MapGet("/", () =>
{
    return "CareBridge API is running";
});

// Return first 20 patients.
// EF Core converts this LINQ query into SQL.
app.MapGet("/api/analytics/department-load",
    (CareBridgeScaffoldContext db) =>
        db.Encounters 
        .Where(e => e.AdmitDate >= DateTime.Today.AddDays(-60)) 
          .Join(db.Departments,
                e => e.DepartmentId,
                d => d.DepartmentId,
                (e, d) => new { e, d }) 
          .GroupBy(x => x.d.Name)
          .Select(g => new
          {
              departmentName = g.Key,
              inpatient = g.Count(x => x.e.EncounterType == "Inpatient"),
              outpatient = g.Count(x => x.e.EncounterType == "Outpatient"),
              ed = g.Count(x => x.e.EncounterType == "ED"),
              total = g.Count()
          })
          .OrderByDescending(x => x.total)
       
          .ToList()
);

app.Run();
