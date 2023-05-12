package com.hsa.sharding;

import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.time.Instant;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.concurrent.ThreadLocalRandom;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class CustomerService {

  private static final String SQL_INSERT_CUSTOMER = "INSERT INTO customer (ID, NAME, BIRTHDAY) VALUES (?,?,?)";
  private static final String SQL_INSERT_CUSTOMER_CATEGORY = "INSERT INTO customer_category (ID, NAME, CATEGORY_ID) VALUES (?,?,?)";


  public void init() {
    try (Connection conn = DriverManager.getConnection(
        "jdbc:postgresql://postgresql-b:5432/postgres", "postgres", "postgres");
        PreparedStatement psInsert = conn.prepareStatement(SQL_INSERT_CUSTOMER)) {

      // commit all or rollback all, if any errors
      conn.setAutoCommit(false); // default true
      for (long i = 1; i <= 1_000_000; i++) {
        psInsert.setLong(1, i);
        psInsert.setString(2, "Lesli");
        psInsert.setDate(3,
            Date.valueOf(DateTimeFormatter.ofPattern("yyyy-MM-dd").withZone(ZoneId.systemDefault())
                .format((Instant.ofEpochSecond(ThreadLocalRandom.current().nextInt(-1598150661, 1526073339))))));
        psInsert.addBatch();
      }

      int[] rows = psInsert.executeBatch();
      conn.commit();
      psInsert.clearBatch();


    } catch (
        SQLException e) {
      System.err.format("SQL State: %s\n%s", e.getSQLState(), e.getMessage());
    } catch (
        Exception e) {
      e.printStackTrace();
    }
  }

  public void initCategories() {
    try (Connection conn = DriverManager.getConnection(
        "jdbc:postgresql://postgresql-b:5432/postgres", "postgres", "postgres");
        PreparedStatement psInsert = conn.prepareStatement(SQL_INSERT_CUSTOMER_CATEGORY)) {

      // commit all or rollback all, if any errors
      conn.setAutoCommit(false); // default true
      for (long i = 1; i <= 1_000_000; i++) {
        psInsert.setLong(1, 1);
        psInsert.setString(2, "Marko");
        int category = 1;
        if (i % 2 == 0) {
          category = 2;
        }
        psInsert.setLong(3, category);
        psInsert.addBatch();
      }

      int[] rows = psInsert.executeBatch();
      conn.commit();
      psInsert.clearBatch();


    } catch (
        SQLException e) {
      System.err.format("SQL State: %s\n%s", e.getSQLState(), e.getMessage());
    } catch (
        Exception e) {
      e.printStackTrace();
    }
  }

}
