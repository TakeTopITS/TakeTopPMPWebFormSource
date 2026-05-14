using NHibernate;
using NHibernate.Cfg;
using System.Collections.Concurrent;

namespace ProjectMgt.DAL
{
    public class SessionFactory
    {
        private static readonly ConcurrentDictionary<string, ISessionFactory> _factories = new ConcurrentDictionary<string, ISessionFactory>();

        public static ISession OpenSession(string AssemblyName)
        {
            var factory = _factories.GetOrAdd(AssemblyName, name =>
            {
                var cfg = new Configuration();
                cfg.AddAssembly(name);
                return cfg.BuildSessionFactory();
            });
            return factory.OpenSession();
        }
    }
}