Console.WriteLine("=== Patient Portal Self-Registration ===");

Console.Write("Enter patient age: ");

string? input = Console.ReadLine();

if (int.TryParse(input, out int age))
{
    if (age >= 18)
        Console.WriteLine("Eligible: patient may self-register.");
    else
        Console.WriteLine("Not eligible: a guardian must register this patient.");
}
else
{
    Console.WriteLine("Invalid input: age must be a whole number.");
}
