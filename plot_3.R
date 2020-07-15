rm(list = ls())
cat("\014")

st <- Sys.time()

require(data.table)
require(ggplot2)
require(ggthemes)
require(rqdatatable)

df <- fread("data/household_power_consumption.txt", na.strings="?", nrows = 1)
optree <- local_td(df) %.>%
    # Filter Dates for 2007-02-01 and 2007-02-02
    select_rows_nse(., Date == "1/2/2007" | Date == "2/2/2007")

df <- fread("data/household_power_consumption.txt", na.strings="?") %.>% optree
df[,dateTime := as.POSIXct(paste(Date, Time), format = "%d/%m/%Y %H:%M:%S")]

df1 <- df %>%
    select(Sub_metering_1, Sub_metering_2, Sub_metering_3, dateTime) %>%
    melt(id.vars = "dateTime")

plot_3 <- ggplot(df1, aes(dateTime, value), group = variable) +
    geom_line(aes(colour = variable)) +
    scale_x_datetime(date_breaks = "1 day", date_labels = "%a") + 
    scale_y_continuous(breaks = scales::pretty_breaks(n = 10)) +
    labs(y = "Energy Sub Metering", x = "", colour = "") +
    scale_colour_tableau(palette = "Classic 10") +
    theme_light() +
    theme(text = element_text(face = "bold"),
          legend.position = c(1, 1), 
          legend.justification = c(1, 1), 
          legend.background = element_rect(colour = NA, fill = "white"))

print(plot_3)
ggsave(plot_3, filename = "codes/ExData_Plotting1/plot_3.png", width = 4, height = 4, dpi = 120)

et <- Sys.time()
print(et-st)
