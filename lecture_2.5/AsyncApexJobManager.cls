public class AsyncApexJobManager {

    public static List<AsyncApexJob> getById(Set<Id> asyncApexJobIds) {
        if (asyncApexJobIds == null || asyncApexJobIds.isEmpty()) {
            return new List<AsyncApexJob>();
        }
        return [
            SELECT id, 
            ParentJobId, 
            ApexClass.Name
            FROM AsyncApexJob
            WHERE Id IN :asyncApexJobIds
        ];
    }
}
